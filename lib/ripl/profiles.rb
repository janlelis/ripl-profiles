require 'ripl'

module Ripl::Profiles
  VERSION = '0.1.4'

  @loaded = []
  
  Ripl::Runner::OPTIONS << ['-p', '--profile NAME', 'Use a profile']

  class << self
    attr_reader :loaded

    def available
      Dir[ File.expand_path( File.join( Ripl.config[:profiles_prefix], '*' ) )].map{ |path|
        File.basename( path ).sub( /#{File.extname(path)}$/,'' )
      }
    end

    def load( names )
      Array(names).each{ |name|
        profile_path = File.expand_path( File.join( Ripl.config[:profiles_prefix], "#{ name }.rb" ) )
        if File.exists? profile_path
          Ripl::Runner.load_rc profile_path
          puts "Loaded profile: #{ name }" if Ripl.config[:profiles_verbose]
          @loaded << name
        else
          warn "ripl: Couldn't load the profile #{ name } at: #{ profile_path }"
        end
      }
    end
  end

  # command shortcuts
  module Commands
    def available_profiles
      Ripl::Profiles.available
    end

    def load_profile( name )
      Ripl::Profiles.load name
    end

    def loaded_profiles
      Ripl::Profiles.loaded
    end
  end

  module Shell
    # load default profile if non is set
    def before_loop
      if Ripl.config[:profiles_default] && Ripl::Profiles.loaded.empty?
        Ripl::Profiles.load Ripl.config[:profiles_default]
      end

      if Ripl.config[:profiles_base]
        Ripl::Profiles.load Ripl.config[:profiles_base]
      end

      # next plugins, load irbrc and make Ripl::Commands available
      super
    end
  end
 
  module Runner
    # add command line option
    def parse_option( option, argv )
      if option =~ /(?:-p|--profile)=?(.*)/
        Ripl::Profiles.load( ($1.empty? ? argv.shift.to_s : $1).split(':') )
      else
        super
      end
    end
  end
end

Ripl::Runner.send :extend,    Ripl::Profiles::Runner
Ripl::Shell.send :include,    Ripl::Profiles::Shell
Ripl::Commands.send :include, Ripl::Profiles::Commands

Ripl.config[:profiles_prefix]  ||= "~/.ripl/profiles/"
Ripl.config[:profiles_verbose] ||= false

# J-_-L
