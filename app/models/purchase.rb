# Models a purchase from the FIWARE OIL Store
#
# {
#   "offering": {
#     "organization": "owner_organization",
#     "name": "offering_name",
#     "version": "offering_version"
#   },
#   "reference": "referencia_de_compra",
#   "customer": "actor_id",
#   "applications": [
#     {
#       "id": 16,
#       "name": "app"
#     },
#     {
#       "id": 20,
#       "name": "app2"
#     }
#   ]
# }
#
class Purchase
  include ActiveModel::Validations

  attr_reader :customer, :applications

  validates :customer, :applications, presence: true

  def initialize(params)
    @customer = Actor.find params[:customer]

    @applications = params[:applications].map{ |h|
      Application.find h[:id]
    }
  end

  def save
    return false unless valid?

    @applications.each do |a|
      a.add_purchaser!(@customer)
    end
  end
end
