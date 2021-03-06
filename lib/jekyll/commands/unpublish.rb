module Jekyll
  module Commands
    class Unpublish < Command
      def self.init_with_program(prog)
        prog.command(:unpublish) do |c|
          c.syntax 'unpublish POST_PATH'
          c.description 'Moves a post back into the _drafts directory'

          c.action do |args, options|
            process(args, options)
          end
        end
      end

      def self.process(args = [], options = {})
        params = UnpublishArgParser.new args, options
        params.validate!

        movement = PostMovementInfo.new params

        mover = PostMover.new movement
        mover.move
      end

    end

    class UnpublishArgParser < Compose::MovementArgParser
      def resource_type
        'post'
      end

      def name
        File.basename(path).sub /\d{4}-\d{2}-\d{2}-/, ''
      end
    end

    class PostMovementInfo
      attr_reader :params
      def initialize(params)
        @params = params
      end

      def from
        params.path
      end

      def to
        "_drafts/#{params.name}"
      end
    end

    class PostMover < Compose::FileMover
      def resource_type
        'post'
      end
    end
  end
end
