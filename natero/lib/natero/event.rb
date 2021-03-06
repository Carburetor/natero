class Natero::Event
  include HTTParty
  include Serializable

  BASE_URI = 'https://events.natero.com'
  VERSION_URI = '/v1'

  attr_reader :account_id, :user_id, :created_at, :session_id, :raw_response

  ##############################################
  ###     Documentation for all endpoints    ###
  ### http://apidocs.natero.com/restapi.html ###
  ##############################################

  REQUIRED_PARAMS = %w{
    account_id
    user_id
    created_at
    session_id
  }
  
  private_class_method def self.post_event(body)
    Natero::Response.new(post(endpoint, { :body => body.to_json, :headers => { 'Content-Type' => 'application/json' } }))
  end

  def self.identify_user(event, details)
    action = 'identifyUser'

    body = event.to_h
    body.merge!({ 'action' => action })
    body.merge!({ 'details' => details })

    post_event(body)
  end

  def self.identify_account(event, details)
    action = 'identifyAccount'

    body = event.to_h
    body.merge!({ 'action' => action })
    body.merge!({ 'details' => details })

    post_event(body)
  end

  def self.session_sync(event, active_duration)
    action = 'sessionSync'

    body = event.to_h
    body.merge!({ 'action' => action })
    body.merge!({ 'active_duration' => active_duration })

    post_event(body)
  end

  def self.module_end(event, module_name, time_spent)
    action = 'moduleEnd'

    body = event.to_h
    body.merge!({ 'action' => action })
    body.merge!({ 'module' => module_name })
    body.merge!({ 'time_spent' => time_spent })

    post_event(body)
  end

  def self.feature(event, feature, module_name, total)
    action = 'feature'

    body = event.to_h
    body.merge!({ 'action' => action })
    body.merge!({ 'feature' => feature })
    body.merge!({ 'module' => module_name })
    body.merge!({ 'total' => total })

    post_event(body)
  end

  def self.endpoint
    Natero.full_endpoint_uri(
      BASE_URI,
      VERSION_URI,
      Natero.configuration.event_auth_key,
      Natero.configuration.event_api_key
    )
  end

  def initialize(params, raw_response = nil)
    missing = REQUIRED_PARAMS - params.keys

    unless missing.empty?
      raise ArgumentError.new("Missing required params #{missing.join(', ')}")
    end

    # Base properties - required
    @account_id = params['account_id']
    @user_id = params['user_id']
    @created_at = params['created_at']
    @session_id = params['session_id']
    @raw_response = raw_response
  end

  def to_json
    serialize
  end
end