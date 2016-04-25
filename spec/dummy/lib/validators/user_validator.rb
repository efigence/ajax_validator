class UserValidator
  def initialize(user)
    @user = user
  end

  def validate
    if @user.name == 'Bad boy'
      @user.errors.add(:name, :evil)
    end
  end
end