require "rubygems"
require "neo4j"
require 'neo4j/extensions/reindexer'

class <%=class_name.pluralize%>Controller < ApplicationController
  around_filter :neo_tx

  def index
    @<%= plural_name%> = <%= class_name%>.all.nodes
  end

  def create
    @<%= singular_name%> = <%= class_name%>.new
    @<%= singular_name%>.update(params[:<%= singular_name%>])
    flash[:notice] = '<%= class_name%> was successfully created.'
    redirect_to(@<%= singular_name%>)
  end

  def update
    @<%= singular_name%>.update(params[:<%= singular_name%>])
    flash[:notice] = '<%= class_name%> was successfully updated.'
    redirect_to(@<%= singular_name%>)
  end

  def destroy
    @<%= singular_name%>.del
    redirect_to(<%= plural_name%>_url)
  end

  def edit
  end

  def show
    @<%= plural_name%> = <%= class_name%>.all.nodes
  end

  def new
    @<%= singular_name%> = <%= class_name%>.value_object.new
  end

  private

  def find_<%= singular_name%>
    @<%= singular_name%> = Neo4j.load_node(params[:id])
  end

  private

  def neo_tx
    Neo4j::Transaction.new
    @<%= singular_name%> = Neo4j.load_node(params[:id]) if params[:id]
    yield
    Neo4j::Transaction.finish
  end
end
