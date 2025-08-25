package announcements;

public class Announcement {
	private int id;
	private String title;
	private String message;
	private String postDate;

	public Announcement(int id, String title, String message, String postDate) {
		this.id = id;
		this.title = title;
		this.message = message;
		this.postDate = postDate;
	}

	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return this.title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getMessage() {
		return this.message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getPostDate() {
		return this.postDate;
	}

	public void setPostDate(String postDate) {
		this.postDate = postDate;
	}
}