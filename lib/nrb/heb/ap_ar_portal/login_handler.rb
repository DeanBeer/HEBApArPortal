module NRB::HEB::ApArPortal
  module LoginHandler

    def logged_in?
      !! @logged_in
    end


    def login
      response = post authenticate_url, authentication_credentials, login_headers, true
      code = response.code.to_i
      @logged_in = code >= 200 && code < 300
      response
    end

  private

    def authentication_credentials
      @authentication_credentials ||= Credential.read_or_ask.to_h
    end


    def authenticate_url
      login_form.action
    end


    def csrf_token
      login_form_page.forms.last.csrfToken
    end


    def login_form_page
      @login_form_page ||= get(URLs[:login_form],[],nil,{},true)
    end


    def login_form
      login_form_page.forms.first
    end


    def login_headers
      { 'X-CSRF-Token' => csrf_token }
    end


  end
end
