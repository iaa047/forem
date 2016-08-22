SimpleForm::Inputs::Base.class_eval do
  private

  # Monkey Patching this method until the next release of simple_form
  # where they fix this bug migrating to Rails 5
  # https://github.com/plataformatec/simple_form/issues/1341
  def decimal_or_float?
    column.type == :float || column.type == :decimal
  end
end
