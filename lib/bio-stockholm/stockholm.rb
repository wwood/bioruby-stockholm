
module Bio
  module Stockholm
    class Reader
      def self.parse_from_file(filename)
        # # STOCKHOLM 1.0
        #
        # #=GS ABK77038.1 DE ammonia monooxygenase subunit A [Cenarchaeum symbiosum A]
        #
        # ABK77038.1         --------------------------------------LTMVWLRRCTHY
        # #=GR ABK77038.1 PP ......................................67889999****
        # #=GC PP_cons       ......................................67889999****
        # #=GC RF            xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        #
        # ABK77038.1         LFIAVVAVNSTLLTINAGDYIFYTDWAWTS--F..TVFSISQTLML....
        # #=GR ABK77038.1 PP **************************9886..4..699********....
        # #=GC PP_cons       **************************9886..4..699********....
        # #=GC RF            xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx..xxxxxxxxxxx....
        # //
        state = :first
        returns = []
        to_return = Bio::Stockholm::Store.new

        File.open(filename).each_line do |line|
          next if line.strip.empty? and state == :first_block

          if state == :first
            unless line == "\# STOCKHOLM 1.0\n"
              raise FormatException, "Currently unable to parse stockholm format files unless they are version 1.0"
            end
            to_return.header = line.strip
            state = :first_block

          elsif state == :first_block
            # Match a GR, GS, etc. "markup" line
            if matches = line.match(/^\#=(..) (\S+)\s+(.*)/)
              if matches[1] == 'GF'
                to_return.gf_features ||= {}
                if to_return.gf_features.key?(matches[2])
                  to_return.gf_features[matches[2]] = to_return.gf_features[matches[2]]+' '+matches[3]
                else
                  to_return.gf_features[matches[2]] = matches[3]
                end
              elsif matches[1] == 'GC'
                to_return.gc_features ||= {}
                if to_return.gc_features.key?(matches[2])
                  to_return.gc_features[matches[2]] = to_return.gc_features[matches[2]]+matches[3]
                else
                  to_return.gc_features[matches[2]] = matches[3]
                end
              else
                # GS, GR, or bad parsing
                unless matches2 = matches[3].match(/(.*?)\s+(.*)/)
                  raise FormatException, "Unable to parse stockholm GS or GR format line: #{line}"
                end
                sequence_identifier = matches[2]
                to_return.records[sequence_identifier] ||= Record.new

                if matches[1] == 'GS'
                  to_return.records[sequence_identifier].gs_features ||= {}

                  if to_return.records[sequence_identifier].gs_features[matches2[1]]
                    to_return.records[sequence_identifier].gs_features[matches2[1]] += matches2[2]
                  else
                    to_return.records[sequence_identifier].gs_features[matches2[1]] = matches2[2]
                  end
                elsif matches[1] == 'GR'
                  to_return.records[sequence_identifier].gr_features ||= {}

                  if to_return.records[sequence_identifier].gr_features[matches2[1]]
                    to_return.records[sequence_identifier].gr_features[matches2[1]] += matches2[2]
                  else
                    to_return.records[sequence_identifier].gr_features[matches2[1]] = matches2[2]
                  end
                else
                  raise FormatException, "Unable to parse stockholm format line: #{line}"
                end
              end
            elsif line.match(/^\/\//)
              returns.push to_return
              to_return = Bio::Stockholm::Store.new
            else
              # Else this is just plain old sequence, aligned
              unless matches = line.match(/^(\S+)\s+(.+)$/)
                raise FormatException, "Unable to parse stockholm format line: #{line}"
              end
              to_return.records[matches[1]] ||= Record.new
              to_return.records[matches[1]].sequence ||= ''
              to_return.records[matches[1]].sequence += matches[2].rstrip
            end
          end
        end

        return returns
      end
    end

    class Store
      # '# STOCKHOLM 1.0'
      attr_accessor :header

      # Array of Record objects, which in turn store sequence, GR and GS features
      attr_accessor :records

      # GF and GC type features
      attr_accessor :gc_features, :gf_features

      def initialize
        @records = {}
      end
    end

    class Record
      # Hash of feature field names to values
      attr_accessor :gr_features, :gs_features

      attr_accessor :sequence
    end

    class FormatException < Exception; end
  end
end
