class ApplicationSerializer
  include JSONAPI::Serializer
  include AuthenticationHelper
end
