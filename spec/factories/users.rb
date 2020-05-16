# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { 'name@hey.com' }
    password { 'namehey123' }
    password_confirmation { 'namehey123' }
    is_admin { true }
  end
end
