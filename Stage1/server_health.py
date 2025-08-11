import subprocess
import platform

server_list = []
results = []

with open("servers.txt", "r") as servers:
    for line in servers:
        clean_line = line.strip()
        server_list.append(clean_line)

param = '-n' if platform.system().lower() == 'windows' else '-c'

for server in server_list:
    command = ['ping', param, '1', server]
    result = subprocess.run(command)
    if result.returncode == 0:
        results.append(server + " is alive!")
    else:
        results.append(server + " is dead!")

with open("serverStatus.html", "w") as report_file:
    report_file.write("<h1>Server Health Check Report</h1>\n")
    for line in results:
        report_file.write(f"<p>{line}</p>\n")
