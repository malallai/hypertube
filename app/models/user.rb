class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :masqueradable, :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :omniauthable, :secure_validatable, email_validation: false

  has_person_name

  has_many :comments, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id
  has_many :services, dependent: :destroy
  has_many :watched_movie, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
end
