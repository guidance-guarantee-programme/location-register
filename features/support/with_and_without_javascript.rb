require 'cucumber/core/version'
if Cucumber::Core::Version.to_s != '1.4.0'
  raise 'Potentially incompatible version of cucumber - This hack is only tested against Cucumber::Core 1.4.0'
end

module Cucumber
  module Core
    module Gherkin
      class AstBuilder
        class FeatureBuilder
          # rubocop:disable Metrics/AbcSize
          def initialize(*)
            super
            @language = Ast::LanguageDelegator.new(attributes[:language], ::Gherkin::Dialect.for(attributes[:language]))
            @background_builder = BackgroundBuilder.new(file, attributes[:background]) if attributes[:background]
            @scenario_definition_builders = map_sd_to_builders(file, attributes[:scenario_definitions])
          end
          # rubocop:enable Metrics/AbcSize

          def map_sd_to_builders(file, scenario_definitions)
            scenario_definitions.flat_map do |sd|
              if sd[:tags].detect { |tag| tag[:name] == '@with_and_without_javascript' }
                map_sd_to_js_and_non_js_builders(file, sd)
              else
                [init_scenario_builder(file, sd)]
              end
            end
          end

          def map_sd_to_js_and_non_js_builders(file, sd)
            scenario_definitions = []

            unless ENV['RUN_JAVASCRIPT_TESTS_ONLY']
              scenario_definitions << (no_js_sd = sd.deep_dup)
              add_tag(no_js_sd, '@with_and_without_javascript', '@no-javascript')
            end

            scenario_definitions << (js_sd = sd.deep_dup)
            add_tag(js_sd, '@with_and_without_javascript', '@javascript')

            scenario_definitions.map { |scenario_definition| init_scenario_builder(file, scenario_definition) }
          end

          def init_scenario_builder(file, sd)
            sd[:type] == :Scenario ? ScenarioBuilder.new(file, sd) : ScenarioOutlineBuilder.new(file, sd)
          end

          def add_tag(attributes, base_tag, new_tag)
            tag = attributes[:tags].detect { |t| t[:name] == base_tag }
            attributes[:tags] << tag.deep_dup.tap { |t| t[:name] = new_tag }
          end
        end
      end
    end
  end
end
