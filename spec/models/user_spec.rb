require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
        :name => "Example User",
        :email => "user@example.com",
        :password => "foobar",
        :password_confirmation => "foobar"
    }
    @user = User.create!(@attr)
  end

  it "se debe crear una nueva instancia con atributos validos" do
    User.create!(@attr)
  end

  it "se debe requerir el nombre" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "se debe requerir el correo del usuario" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "deben ser rechazados los nombres muy largos (>= 51)" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "deberia aceptar correos validos" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "no deberia aceptar correos invalidos" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end


  describe "validacion de password" do
    it "el password es requerido" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end

    it "se debe requerir la confirmacion del password" do
      User.new(@attr.mege(:password_confirmation => "invalid"))
    end

    it "se debe rechazar passwords cortos" do
      short = a * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "se debe rechazar password largos" do
      long = a * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end

  end

  describe "password cifrado" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "debe tener un atributo password cifrado" do
      @user.should respond_to(:encrypted_password)
    end
    it "debe tener un password cifrado no blanco" do
      @user.encrypted_password.should_not be_blank
    end
  end

  describe "has_password method" do
    it "deberia ser correcto si el password coincide" do
      @user.has_password?(@attr[:password]).should be_true
    end

    it "deberia ser incorrecto si el password no coincide" do
      @user.has_password?("invalid").should be_false
    end
  end

  describe "metodo de autenticacion" do
    it "deberia retornar nulo si el password y el mail no coinciden" do
      wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
      wrong_password_user.should be_nil
    end

    it "deberia retornar nulo para un mail no existente" do
      no_existent_user = User.authenticate("bar@foo.com", @attr[:password])
      no_existent_user.should be_nil
    end

    it "debe retornar un objeto usuario con el pass y user coinciden" do
      matching_user = User.authenticate(@attr[:email], @attr[:password])
      matching_user.should ==  @user
    end
  end

end
