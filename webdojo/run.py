#!/usr/bin/python3

from http.server import BaseHTTPRequestHandler
from http.server import HTTPServer

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        with open("./app/index.html") as f:
            html = f.read()

            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.send_header("Content-Length", len(html))
            self.end_headers()

        self.wfile.write(bytes(html, "utf8"))
        return

def run():
    server_address = ('', 8080)
    httpd = HTTPServer(server_address, RequestHandler)
    httpd.serve_forever()

if __name__ == "__main__":
    run()
