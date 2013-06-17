
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
        to_return = Bio::Stockholm::Store.new

        File.open(filename).each_line do |line|
          next if line.strip.empty? and state == :first_block

          if state == :first
            unless line == "\# STOCKHOLM 1.0\n"
              raise FormatException, "Currently unable to parse stockholm format files unless they are version 1.0"
            end
            to_return.version = line.strip
            state = :first_block

          elsif state == :first_block
            if matches = line.match(/^\#=GS\s+(.+?)\s+DE\s+(.+)$/)
              to_return.records[matches[1]] = Record.new
              to_return.records[matches[1]].description = matches[2]
            elsif line == "//\n"
              return to_return
            else
              splits = line.strip.split(/\s+/)
              next if splits.length > 2 #Currently ignore the annotation lines

              identifier = splits[0]
              seq = splits[1]
              unless splits.length == 2
                raise FormatException, "Unexpected line in STOCKHOLM format: #{line}"
              end
              to_return.records[identifier].sequence ||= ''
              to_return.records[identifier].sequence += seq
            end
          end
        end
        # If reached here, there was no // most probably
        raise FormatException, "Unexpected end of stockholm format data"
      end
    end

    class Store
      attr_accessor :version
      attr_accessor :records

      def initialize
        @records = {}
      end
    end

    class Record
      attr_accessor :description

      attr_accessor :sequence
    end

    class FormatException < Exception; end
  end
end
