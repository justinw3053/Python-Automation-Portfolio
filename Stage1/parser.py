#Create empty list to store errors
found_errors = []

#Open and read syslog, adding any errors to the list
with open("/var/log/syslog", "r") as log_file:
    for line in log_file:
        if "error" in line:
            found_errors.append(line)  # .append() adds an item to the list.

#Check the list for any errors
if len(found_errors) > 0:
    # If errors were found, send an email
    import smtplib

    sender_email = "justin@jwin.io"
    reciever_email = "justin@jwin.io"
    password = "odxk fnfb fizx kubq"

    # Build a message string from the list of errors
    message = "Subject: Errors Found in Syslog!\n\n"
    message += "".join(found_errors) # Joins all lines in the linst into one string

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        server.login(sender_email, password)
        server.sendmail(sender_email, reciever_email, message)
