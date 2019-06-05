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
      flash[:message] = "Your address at #{@address.address} has been saved"
      redirect_to profile_addresses_path
    else
      flash[:danger] = @address.errors.full_messages
      render :new
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      flash[:success] = "Your address at #{@address.address} has been updated!"
      redirect_to profile_addresses_path
    else
      flash[:danger] = @address.errors.full_messages
      @address = Address.find(params[:id])
      render :edit
    end
  end

  def destroy
    @address = Address.find(params[:id])
    if @address.orders.any? == true
      flash[:message] = "Address is active on a pending order"
      redirect_to profile_addresses_path
    else
      @address.destroy
      flash[:message] = "Address has been deleted"
      redirect_to profile_addresses_path
    end
  end

  private

  def address_params
    params.require(:address).permit(:address, :city, :state, :zip, :nickname)
  end

end
