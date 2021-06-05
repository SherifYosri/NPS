class BiMemberMailer < ApplicationMailer
  def feedbacks_report_email(email, report_location)
    attachments['feedbacks_report.txt'] = File.read(report_location)
    
    mail({
      to: email,
      from: configatron.emails.from,
      subject: "Your feedbacks report is ready!"
    })
  end
end