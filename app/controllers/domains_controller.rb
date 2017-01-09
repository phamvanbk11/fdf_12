class DomainsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_domain, only: [:show, :update]
  before_action :redirect_to_root_domain, only: :show
  before_action :check_user_status_for_action, only: :index

  def index
    @domains = current_user.domains.by_creator current_user.id
  end

  def new
  end

  def show
    @domains = Domain.professed
    @categories = Category.all
    @tags = ActsAsTaggableOn::Tag.all
    @shops = @domain.shops.top_shops.decorate
    @products = @domain.products.top_products
  end

  def create
    @domain = Domain.new domain_params
    save_domain = SaveDomainService.new(@domain, current_user).save
    flash[:success] = save_domain
    redirect_to new_user_domain_path(id: @domain.id)
  end

  def update
    if @domain.update_attributes status: params[:status]
      flash[:success] = t "save_domain_successfully"
    else
      flash[:danger] = t "save_domain_not_successfully"
    end
    redirect_to :back
  end

  private
  def domain_params
    params.require(:domain).permit(:name, :status).merge! owner: current_user.id
  end
end
