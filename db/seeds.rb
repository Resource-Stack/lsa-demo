# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


a = ReportType.create(title: 'IoT Data')
 ReportValue.create(title: 'Other IoT', report_type_id: a.id)
 ReportValue.create(title: 'VoIP', report_type_id: a.id)
 ReportValue.create(title: 'Mobile', report_type_id: a.id)
 ReportValue.create(title: 'Point of Sale', report_type_id: a.id)
 ReportValue.create(title: 'Cameras', report_type_id: a.id)
 ReportValue.create(title: 'Printers', report_type_id: a.id)
ab = ReportType.create(title: 'Wireless')
 ReportValue.create(title: 'Corporate Wireless', report_type_id: ab.id)
 ReportValue.create(title: 'Guest Wireless', report_type_id: ab.id)
ac = ReportType.create(title: 'Endpoint Compliance')
 ReportValue.create(title: 'No AnyConnect Unresolved', report_type_id: ac.id)
 ReportValue.create(title: 'No SCCM Agent Unresolved', report_type_id: ac.id)
 ReportValue.create(title: 'No SEP Agent Unresolved', report_type_id: ac.id)
 ReportValue.create(title: 'Tanium Agent Unresolved', report_type_id: ac.id)
ad = ReportType.create(title: 'Security Risks')
 ReportValue.create(title: 'Telnet Enabled Switches', report_type_id: ad.id)
 ReportValue.create(title: 'Port 80 Enable Devices', report_type_id: ad.id)
 ReportValue.create(title: 'FTP Enable Devices', report_type_id: ad.id)
 ReportValue.create(title: 'Telnet Enabled Devices', report_type_id: ad.id)
 ReportValue.create(title: 'Admins Logged in', report_type_id: ad.id)
 ReportValue.create(title: 'USB Devices Deteched', report_type_id: ad.id)
ae = ReportType.create(title: 'Software Vulnerabilties')
 ReportValue.create(title: 'Other', report_type_id: ae.id)
 ReportValue.create(title: 'Microsoft', report_type_id: ae.id)
 ReportValue.create(title: 'Java', report_type_id: ae.id)
 ReportValue.create(title: 'Adobe', report_type_id: ae.id)




