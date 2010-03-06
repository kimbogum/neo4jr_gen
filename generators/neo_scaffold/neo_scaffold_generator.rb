require 'optparse'

module Neo4jrGen

    #a generated attribute class that removes the dependancy on
    #active record.
    class GeneratedAttribute
      attr_accessor :name, :type

      def initialize(name, type)
        @name, @type = name, type.to_sym
      end

      def field_type
        @field_type ||= case type
          when :integer, :float, :decimal   then :text_field
          when :datetime, :timestamp, :time then :datetime_select
          when :date                        then :date_select
          when :string                      then :text_field
          when :text                        then :text_area
          when :boolean                     then :check_box
          else
            :text_field
        end
      end

      def default
        @default ||= case type
          when :integer                     then 1
          when :float                       then 1.5
          when :decimal                     then "9.99"
          when :datetime, :timestamp, :time then Time.now.to_s(:db)
          when :date                        then Date.today.to_s(:db)
          when :string                      then "MyString"
          when :text                        then "MyText"
          when :boolean                     then false
          else
            ""
        end
      end
    end

end




class NeoScaffoldGenerator < Rails::Generator::NamedBase
  def manifest
    puts "Actions #{actions}"
    puts "Class name #{class_name}"




    puts "attributes #{attributes}"

    record do |m|
      m.template "model.rb", File.join('app/models', "#{singular_name}.rb")
      m.template "controller.rb", File.join('app/controllers', "#{plural_name}_controller.rb")
      m.directory File.join('app/views', plural_name)
      m.template "view_index.html.erb", File.join('app/views', plural_name, "index.html.erb")
      m.template "view_show.html.erb", File.join('app/views', plural_name, "show.html.erb")
      m.template "view_new.html.erb", File.join('app/views', plural_name, "new.html.erb")
      m.template "view_edit.html.erb", File.join('app/views', plural_name, "edit.html.erb")
    end
  end

  #override the attributes method to use GeneratedAttribute (not dependant on active record)
  def attributes
    @attributes ||= @args.collect do |attribute|
      Neo4jrGen::GeneratedAttribute.new(*attribute.split(":"))
    end
  end
end

