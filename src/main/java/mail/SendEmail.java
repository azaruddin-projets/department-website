package mail;

import java.io.IOException;
import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.Message.RecipientType;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class SendEmail {
	Session newSession = null;
	MimeMessage mimeMessage = null;

	public static void main(String[] args) throws AddressException, MessagingException, IOException {
		SendEmail mail = new SendEmail();
		mail.setupServerProperties();
		mail.draftEmail();
		mail.sendEmail();
	}

	private void sendEmail() throws MessagingException {
		String fromUser = "shaikazaruddin913@gmail.com";
		String fromUserPassword = "gpsthofyxpyfqaql";
		String emailHost = "smtp.gmail.com";
		Transport transport = this.newSession.getTransport("smtp");
		transport.connect(emailHost, fromUser, fromUserPassword);
		transport.sendMessage(this.mimeMessage, this.mimeMessage.getAllRecipients());
		transport.close();
		System.out.println("Email successfully sent!!!");
	}

	private MimeMessage draftEmail() throws AddressException, MessagingException, IOException {
		String[] emailRecipients = new String[]{"shaikazaruddin913@gmail.com"};
		String emailSubject = "Test Mail";
		String emailBody = "Test Body of my email";
		this.mimeMessage = new MimeMessage(this.newSession);
		this.mimeMessage.setFrom(new InternetAddress("shaikazaruddin913@gmail.com"));
		String[] var7 = emailRecipients;
		int var6 = emailRecipients.length;

		for (int var5 = 0; var5 < var6; ++var5) {
			String recipient = var7[var5];
			this.mimeMessage.addRecipient(RecipientType.TO, new InternetAddress(recipient));
		}

		this.mimeMessage.setSubject(emailSubject);
		MimeBodyPart bodyPart = new MimeBodyPart();
		bodyPart.setContent(emailBody, "text/html");
		MimeMultipart multiPart = new MimeMultipart();
		multiPart.addBodyPart(bodyPart);
		this.mimeMessage.setContent(multiPart);
		return this.mimeMessage;
	}

	private void setupServerProperties() {
		Properties properties = System.getProperties();
		properties.put("mail.smtp.port", "587");
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.starttls.enable", "true");
		properties.put("mail.smtp.ssl.protocols", "TLSv1.2");
		properties.put("mail.smtp.ssl.trust", "smtp.gmail.com");
		this.newSession = Session.getDefaultInstance(properties, new Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication("shaikazaruddin913@gmail.com", "gpsthofyxpyfqaql");
			}
		});
	}
}