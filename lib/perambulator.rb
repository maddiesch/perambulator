require 'perambulator/config'
require 'perambulator/configuration'
require 'perambulator/encryption'
require 'perambulator/error'
require 'perambulator/kv'
require 'perambulator/local_cache'
require 'perambulator/local_kv'
require 'perambulator/parameter_store'
require 'perambulator/presence'
require 'perambulator/version'
require 'perambulator/yaml'

module Perambulator
end

Object.include(Perambulator::Presence)

Peram = Perambulator unless defined?(Peram)
