# Cargar automáticamente todos los archivos en el directorio support
Dir[File.join(__dir__, '*.rb')].each { |file| require file }
