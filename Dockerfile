FROM frappe/erpnext:v15.55.4

# Add lending app
RUN bench get-app https://github.com/frappe/lending.git && \
    cd /home/frappe/frappe-bench && \
    bench build --app lending
