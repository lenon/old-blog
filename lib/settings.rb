class Settings < Settingslogic
  source ENV["SETTINGS_FILE"] || "config/settings.yml"
  namespace ENV["RACK_ENV"]
end
