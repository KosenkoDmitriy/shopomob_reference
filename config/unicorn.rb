# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/home/dmitry/prj/rails/shopomob_reference"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/home/dmitry/prj/rails/shopomob_reference/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "/home/dmitry/prj/rails/shopomob_reference/log/unicorn.log"
stdout_path "/home/dmitry/prj/rails/shopomob_reference/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.shopomob_reference.sock"
listen "/tmp/unicorn.shopomob.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30
