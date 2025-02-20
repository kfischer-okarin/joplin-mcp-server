module Tools
  class ListNotebooks
    def initialize(api_client)
      @api_client = api_client
    end

    def call
      notebooks = @api_client.get_all_items('/folders', query: { fields: 'id,title,parent_id' })

      notebooks_by_parent_id = {}

      notebooks.each do |notebook|
        parent_id = notebook['parent_id']
        (notebooks_by_parent_id[parent_id] ||= []) << notebook
      end

      result_lines = notebooks_lines(notebooks_by_parent_id[''], notebooks_by_parent_id: notebooks_by_parent_id)
      result_lines.join
    end

    private

    def notebooks_lines(notebooks, indent: 0, notebooks_by_parent_id:)
      result = []
      indent_spaces = ' ' * indent
      sort_notebooks(notebooks).each do |notebook|
        id = notebook['id']
        result << "#{indent_spaces}#{notebook['title']} (id: \"#{id}\")\n"
        child_notebooks = notebooks_by_parent_id[id]
        if child_notebooks
          result.concat(
            notebooks_lines(child_notebooks, indent: indent + 2, notebooks_by_parent_id: notebooks_by_parent_id)
          )
        end
      end
      result
    end

    CHARACTER_BEFORE_A = ('A'.ord - 1).chr

    # Ensure that notebooks starting with '[0]' are sorted first
    def sort_notebooks(notebooks)
      notebooks.sort_by { |notebook| notebook['title'].gsub('[', CHARACTER_BEFORE_A) }
    end
  end
end
