component output="false" {
	public void function _403(event, rc, prc) {
		event.renderData(data="Access Denied", statusCode=403, statusText="Access Denied");
	}

	public void function _404(event, rc, prc) {
		event.renderData(data="Page Not Found", statusCode=404, statusText="Page Not Found");
	}
}