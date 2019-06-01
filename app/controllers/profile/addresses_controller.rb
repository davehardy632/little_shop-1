class Profile::AddressesController < ApplicationController

  def index
    @user = current_user
    @addresses = current_user.addresses
  end

  def new
    @user = current_user
    @address = Address.new
  end

  def create
    @user = current_user
    @address = Address.new(address_params)
    @user.addresses << @address
    if @address.save
      flash[:message] = "Your address at #{@address.address_line} has been saved"
      redirect_to profile_addresses_path
    else
      render :new
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      flash[:success] = "Your address at #{@address.address_line} has been updated!"
      redirect_to profile_addresses_path
    else
      flash[:danger] = @address.errors.full_messages
      @address = Address.find(params[:id])
      render :edit
    end
  end

  private

  def address_params
    params.require(:address).permit(:address_line, :city, :state, :zip, :nickname)
  end

end
