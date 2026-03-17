class ServiceResult
  attr_reader :payload, :errors

  def initialize(success:, payload: {}, errors: [])
    @success = success
    @payload = payload
    @errors = errors
  end

  def success? = @success
  def failure? = !@success
end
