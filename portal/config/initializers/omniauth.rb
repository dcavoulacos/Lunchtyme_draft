OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '598601033518548', 'a091edbee36349bac46a242c6131e778'
end
