class ApplicationService
  def self.call(...)
    new(...).call
  end

  private

  def success(payload = {})
    ServiceResult.new(success: true, payload: payload)
  end

  def failure(errors)
    ServiceResult.new(success: false, errors: Array(errors))
  end
end
