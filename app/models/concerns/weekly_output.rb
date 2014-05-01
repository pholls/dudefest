module WeeklyOutput
  extend ActiveSupport::Concern

  public
    def weekly_output
      html = "<a href='#{google_doc_link}'>Add it to your weekly output!</a>"
      html.html_safe
    end

  private
    def google_doc_link
      "https://docs.google.com/spreadsheet/ccc?key=0AvXIsPBDZM-VdFNscld1YVBGTjdORG1pNTNFbFkxc1E"
    end
end
