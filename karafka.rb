# frozen_string_literal: true

class KarafkaApp < Karafka::App
  kafka_host = Figaro.env.kafka_host

  setup do |config|
    config.kafka = { 
      'bootstrap.servers': kafka_host,
      'security.protocol': 'ssl',
      'ssl.certificate.location': './config/ssl/access-certificates.cert',
      'ssl.key.location': './config/ssl/access-key.key',
      'ssl.ca.location': './config/ssl/ca-certificates.pem'
    }
    config.client_id = 'ruby-kafka-consumer'
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Karafka.monitor.subscribe(Karafka::Instrumentation::LoggerListener.new)
  # Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

  # This logger prints the producer development info using the Karafka logger.
  # It is similar to the consumer logger listener but producer oriented.
  Karafka.producer.monitor.subscribe(
    WaterDrop::Instrumentation::LoggerListener.new(Karafka.logger)
  )

  routes.draw do
    # Uncomment this if you use Karafka with ActiveJob
    # You need to define the topic per each queue name you use
    # active_job_topic :default
    topic :example do
      consumer LearningConsumer
    end
  end
end
