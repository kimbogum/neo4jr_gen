class <%= class_name %>
    include Neo4j::NodeMixin

    property :<%= (attributes.collect {|attribute| attribute.name.to_sym})*',:' %>

    index :<%= (attributes.collect {|attribute| attribute.name.to_sym})*',:' %>
end
