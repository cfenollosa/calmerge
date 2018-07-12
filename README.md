# calmerge
Merge various calendar events into a single calendar

## Usage

1. Edit the script file to check the configuration and edit input and output file names
2. Run `./calmerge.sh`

## Put in production

You will probably want to expose the output calendar into some cloud service.

The easiest way is to write the output file into a dropbox folder and share the public URL of that file.

The difficult way is to set up a web server on some machine (local or cloud, recommended cloud) and serve the file from there.

To refresh the calendars regularly you should run the script every few minutes, for example, every 10 minutes. The easiest way is to use a cron job. Run `crontab -e` and add the following line:

`*/10 * * * * /path/to/the/script/calmerge.sh`

Then, the script will download the input calendars every run, and generate a merged calendar that will be served instantly by the web server or Dropbox.
