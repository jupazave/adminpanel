module Adminpanel
  class AuthsController < ApplicationController
  private
  def auth_params
    params.require(:auth).permit(:name, :value, :key, :fb_page_access_key)
  end
  end
end
