class HomeController < ApplicationController
  include ActiveModel::Validations

  before_action :sanitize_params, only: :create
  before_action :validate_params, only: :create

  def new; end

  def create
    begin
      @results = AllocationProration.allocate_investments(params)
      flash[:notice] = t(:calculation_success) if @results
    rescue
      flash[:notice] = t(:calculation_error)
    ensure
      render :new
    end
  end

  private

  def sanitize_params
    params[:allocation_amount] = params[:allocation_amount].to_i
    params[:investor_amounts].reject!{|e| e[:name].empty?}
    params[:investor_amounts].each do |investor|
      investor[:requested_amount] = investor[:requested_amount].to_i
      investor[:average_amount] = investor[:average_amount].to_i
    end
  end

  def validate_params
    if params[:investor_amounts].size != params[:investor_amounts].pluck(:name).uniq.size
      flash[:notice] = t(:duplicate_investor_error)
      render :new
    end
  end
end