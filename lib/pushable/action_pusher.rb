class ActionPusher < AbstractController::Base
  include AbstractController::Rendering
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  include Rails.application.routes.url_helpers
  helper ApplicationHelper
  include ApplicationHelper
  self.view_paths = "app/views"

  NET_HTTP_EXCEPTIONS = [Timeout::Error, Errno::ETIMEDOUT, Errno::EINVAL,
                         Errno::ECONNRESET, Errno::ECONNREFUSED, EOFError,
                         Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
                         Net::ProtocolError]


  def push(event, channel, object)
    url = URI.parse("#{Pushable::Rails::Faye.address}/faye")
    req = Net::HTTP::Post.new(url.path)

    req.form_data = { message: { channel: "/sync/#{channel}",
                                    data: { object: render_for_push(object),
                                             event: event } }.to_json }
    req.basic_auth url.user, url.password if url.user

    http = Net::HTTP.new(url.host, url.port)
    if url.scheme == "https"
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    http.start do |https|
      https.request(req)
    end
  rescue *NET_HTTP_EXCEPTIONS => exception
    ::Rails.logger.error("")
    ::Rails.logger.error("ActionPusher encountered an exception:")
    ::Rails.logger.error(exception.class.name)
    ::Rails.logger.error(exception.message)
    ::Rails.logger.error(exception.backtrace.join("\n"))
    ::Rails.logger.error("")
  end

  def render_for_push(object)
    render_to_hash(partial: "#{object.class.name.underscore.pluralize}/#{object.class.name.underscore}", object: object)
  end
end
