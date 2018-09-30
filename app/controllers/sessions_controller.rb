class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    # haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]
    # talletetaan sessioon kirjautuneen käyttäjän id (jos käyttäjä on olemassa)
    if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect_to user_path(user), notice: "Welcome back!"
    # uudelleen ohjataan käyttäjä omalle sivulleen
    else
      redirect_to signin_path, notice: "Username and/or password mismatch"
    end
  end


  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
