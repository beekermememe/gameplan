Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
      :auth0,
      'D2mqvzdyQWhJSY7P3NEQPaDJm5O1vx2x',
      'T9BtS_PEHRRond7B_LZlKFcCfQkg2jsWzqpbI8BDSmk3TRgl5T8gVCkYl0tmwvBi',
      'iroptimizer.auth0.com',
      callback_path: "/auth/oauth2/callback",
      authorize_params: {
          scope: 'openid profile',
          audience: 'https://iroptimizer.auth0.com/userinfo'
      }
  )
end