require 'logger'
require 'timezone'

require './lib/database_connector'

class AppConfigurator
  def configure
    setup_i18n
    setup_database
    setup_timezone
  end

  def get_token
    YAML::load(IO.read('config/secrets.yml'))['telegram_bot_token']
  end

  def get_botan_token
    YAML::load(IO.read('config/secrets.yml'))['botan_token']
  end

  def get_logger
    Logger.new(STDOUT, Logger::DEBUG)
  end


  private

  def setup_i18n
    I18n.load_path = Dir['config/locales.yml']
    I18n.locale = :en
    I18n.backend.load_translations
  end

  def setup_timezone
    Timezone::Lookup.config(:google) do |c|
      c.api_key = 'AIzaSyDJboBy-w3WuXBrUPDp3bb6tRF8hfEnggo'
    end
  end
  
  def setup_database
    DatabaseConnector.establish_connection
  end
end
