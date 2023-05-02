class WelcomeController < ApplicationController
  def index
    if params.has_key? :register
      @register = true
    end
    render 'index'
  end
end
