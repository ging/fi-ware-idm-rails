User.class_eval do
  # Overwrite User#represented method
  #
  # Right now, we do not need confirmation from users to represent
  def represented
    contact_subjects(direction: :received) do |q|
      q.joins(sent_ties: { relation: :permissions }).
        merge(Permission.represent)
    end
  end
end
