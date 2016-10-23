module WeeklyOutput
  extend ActiveSupport::Concern

  included do
    rails_admin do
      configure :weekly_output do
        read_only true
        help { bindings[:object].weekly_output_help }
      end
    end
  end

  public
    def weekly_output
      "<a href='#{google_doc_link}'>Add it to your weekly output!</a>".html_safe
    end

  private
    def google_doc_link
      "https://docs.google.com/spreadsheet/ccc?key=0AvXIsPBDZM-VdFNscld1YVBGTjdORG1pNTNFbFkxc1E"
    end
end
