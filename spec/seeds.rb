class Seed
  def self.load_data
    # BI Team Member User
    [
      { name: "BI Team Member", email: "sherif0yosri@gmail.com", password: 'iam_bi_team_member' }
    ].each do |attrs|
      BiMember.create!(attrs) unless BiMember.find_by_email(attrs[:email])
    end

    # Seller Users
    [
      { name: "Seller A", email: "seller_a@NPS.com", password: 'iam_seller_a' },
      { name: "Seller B", email: "seller_b@NPS.com", password: 'iam_seller_b' }
    ].each do |attrs|
      Seller.create!(attrs) unless Seller.find_by_email(attrs[:email])
    end

    # Realtor Users
    [
      { name: "Realtor A", email: "realtor_a@NPS.com", password: 'iam_realtor_a' },
      { name: "Realtor B", email: "realtor_b@NPS.com", password: 'iam_realtor_b' }
    ].each do |attrs|
      Realtor.create!(attrs) unless Realtor.find_by_email(attrs[:email])
    end

    # Deals
    [
      { seller: Seller.first, realtor: Realtor.first, feedback_token: SecureRandom.base58(100) },
      { seller: Seller.last, realtor: Realtor.last, feedback_token: SecureRandom.base58(100) }
    ].each do |attrs|
      Deal.create!(attrs) unless Deal.where(seller: attrs[:seller], realtor: attrs[:realtor]).any?
    end
  end
end