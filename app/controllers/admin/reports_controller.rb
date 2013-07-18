module Admin
  class ReportsController < ApplicationController
    before_filter :admin_only
  end
end
