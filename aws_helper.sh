#!/bin/bash

title="AWS Helper"
author="@gLoveiko"
# this script yields the following HTML5 file:
html_file=$(pwd)"/aws_helper.html"

###############
# Build Steps #
###############

head()
# write doctotype and header for html file
# Entries:
#	$1 page title  
{
echo -e "<!DOCTOTYPE html>\n\n<html>\n\t<head>\n\t\t<meta charset="utf-8" />\n\t\t<title>$*</title>\n\t</head>"
}

welcome()
# write welcoming message 
# Entries:
#	$1 page title 
#	$2 author
{
echo -e "\t <body>" 
echo -e "\t\t <p> Welcome on $1 $2! <br />" 
echo -e "\t\t Here are aggregated many tutorials which provide all the steps required to realize your own set up with AWS.</p>\n"
}

ending()
# write ending html code 
{
echo -e "\t </body>"
echo "</html>"
}

menu()
# write list of steps required to complete tutorial
{
echo -e "\t\t <h1> Steps </h1>"
echo -e "\t\t <ul>"
COUNTER=0
for step in "$@"
do
	echo -e "\t\t\t <li> step $COUNTER: $step </li>"
	let COUNTER=COUNTER+1
done
echo -e "\t\t </ul>\n"
}

be_ready ()
# write steps on how to access AWS
{
echo -e "\t\t <h1> Step $step_number: get to AWS </h1>"
echo -e "\n<p>> Go to <em>https://www.vocareum.com/</em><br />\n> Go to <em>My Classes/AWS Architecture Class</em><br />\n> Click on <strong>AWS Console</strong><br />\n</p>"
let step_number++
}

create_a_vpc ()
# write steps on how to create a vpc (virtual private cloud)
# Entries:
#	$1 tag name of vpc
{
let n_VPC++
tagvpc=$main_tag-vpc$1
echo -e "\t\t <h1> Step $step_number: create a VPC </h1>"
echo -e "\n<p>> Go to <em>Services/VPC/Your VPCs</em><br />\n> Click on <strong>Create VPC</strong><br />\n> Fill in:<br />"
RN1=$(($RANDOM % 256 )) 
RN2=$(($RANDOM % 256 ))
echo -e "Name tag: <mark>$1</mark><br />\nIPv4 CIDR block: <mark>$RN1.$RN2.0.0/16</mark><br />\n> Click on <strong>Create</strong>\n</p> "
let step_number++
}

create_a_subnet ()
# write steps on how to create a private subnet within a vpc
# Entries:
#	$1 Block #1 of VPC
#	$2 Block #2 of VPC
#	$3 AZ (No preference, us-east-1a, us-east-1b, us-east-1c...)
#	$4 VPC tag name
#	$5 subnet tag name

{
let n_subnets++
let n_private_subnets++
echo -e "\t\t <h1> Step $step_number: create private subnet </h1>"
echo -e "\n<p>> Go to <em>Services/VPC/Subnets</em><br />\n> Click on <strong>Create subnet</strong><br />\n> Fill in:<br />"
echo -e "Name tag: <mark>$5</mark><br />\nVPC: <mark> $4</mark><br />\nAvailability Zone: <mark>$3</mark><br />\nIPv4 CIDR block: <mark>$1.$2.$n_subnets.0/24</mark><br />\n> Click on <strong>Create</strong>\n</p> "
let step_number++
}

create_an_IG ()
# write steps on how to create an internet gateway that connects a vpc to internet
# Entries:
#	$1 internet gateway tag name
{
let n_IGW++
echo -e "\t\t <h1> Step $step_number: create internet gateway $1 </h1>"
echo -e "\n<p>> Go to <em>Services/VPC/Internet Gateways</em><br />\n> Click on <strong>Create an internet gateway</strong><br />\n> Fill in:<br />"
echo -e "Name tag: <mark>$1</mark><br />\n> Click on <strong>Create</strong> <br /> </p> \n"
let step_number++
}


attach_an_IG ()
# write steps on how to attach an internet gateway to a vpc
# Entries:
#	$1 tag name of VPC
#	$2 tag name of igw
{
echo -e "\t\t <h1> Step $step_number: attach internet gateway $2 to VPC $1</h1>"
echo -e "\n<p>> Go to <em>Services/VPC/Internet Gateways</em><br />\n> Click on (select) <strong> $2 </strong> <br />\n> Click on <strong> Actions </strong> <br />\n> Click on <strong> Attach to VPC </strong> <br />\n> Fill in:<br />"
echo -e "VPC: <mark>$1</mark><br />\n> Click on <strong>Attach</strong> <br /> </p> \n"
let step_number++
}

connect_subnet_to_igw ()
# write steps on how to connect a subnet to internet
# Entries:
#	$1 igw tag name
#	$2 subnet tag name
{
echo -e "\t\t <h1> Step $step_number: connect a subnet $2 to igw $1 (make subnet public)</h1>"
let n_private_subnets--
let n_public_subnets++
echo -e "\n<p>> Go to <em>Services/VPC/Subnets</em><br />\n> Click on (select) <strong> $2 </strong> <br />\n> Below click on <strong> Route Table </strong> <br />\n> Click on <strong> Route Table: *ID blue link* </strong> (NOT on Edit route table association) <br />\n> Below click on <strong> Routes </strong> <br />\n> Click on <strong> Edit routes </strong> <br />\n> Click on <strong> Add route </strong> <br />\n> Fill in:<br />"
echo -e "Destination: <mark>0.0.0.0/0</mark><br />\nTarget: <mark>Internet Gateway/$1</mark><br />\n> Click on <strong>Save routes</strong> <br /></p> \n"
let step_number++
}

connect_subnet_to_nat_instance ()
# write steps on how to connect a subnet to internet
# Entries:
#	$1 nat instance tag name
#	$2 subnet tag name
{
echo -e "\t\t <h1> Step $step_number: connect a subnet $2 to NAT instance $1 </h1>"
let n_private_subnets--
let n_public_subnets++
echo -e "\n<p>> Go to <em>Services/VPC/Subnets</em><br />\n> Click on (select) <strong> $2 </strong> <br />\n> Below click on <strong> Route Table </strong> <br />\n> Click on <strong> Route Table: *ID blue link* </strong> (NOT on Edit route table association) <br />\n> Below click on <strong> Routes </strong> <br />\n> Click on <strong> Edit routes </strong> <br />\n> Click on <strong> Add route </strong> <br />\n> Fill in:<br />"
echo -e "Destination: <mark>0.0.0.0/0</mark><br />\nTarget: <mark>Instance/$1</mark><br />\n> Click on <strong>Save routes</strong> <br /></p> \n"
let step_number++
}

create_an_EC2_instance ()
# write steps on how to create an internet gateway that connects a vpc to internet
# Entries:
#	$1 if "Auto-assign Public IP = yes" then enable Auto-assign Public IP
#	   if not then keep default Auto-assign Public IP option (disable)
#	$2 VPC tag name
#	$3 subnet tag name
#	$4 tag of ec2 instance 
#	$5 tag of SG of instance
#	$6 tag of keypair of instance  
{
let n_ec2_instance++
echo -e "\t\t <h1> Step $step_number: create an EC2 instance $4</h1>"
echo -e "\n<p>> Go to <em>Services/EC2/Instances</em><br />\n> Click on <strong>Launch Instance</strong><br />\n> Choose a 'Free tier eligible' AMI and click on <strong>Select</strong><br />\n> Click on <strong>Next: Configure Instance Details</strong><br />\nRemark: here we could have chosen our instance based on CPU capacity, GPU capacity, RAM etc...<br />\n> Fill in:<br />"
if [ "$1" == "Auto-assign Public IP = yes" ]
then
	echo -e "Number of instances: <mark>1</mark><br />\nNetwork: <mark>$2</mark><br />\nSubnet: <mark>$3</mark><br />\nAuto-assign public IP: <mark>Enable</mark> <br />\n> Click on <strong>Next: Add Storage</strong> <br />\n> Click on <strong>Next: Add Tags</strong> <br /> \n>Fill in:<br />"
else
	echo -e "Number of instances: <mark>1</mark><br />\nNetwork: <mark>$2</mark><br />\nSubnet: <mark>$3</mark><br />\n> Click on <strong>Next: Add Storage</strong> <br />\n> Click on <strong>Next: Add Tags</strong> <br /> \n>Fill in:<br />"
fi
echo -e "Key: <mark>Name</mark><br />\nValue: <mark>$4</mark><br />\n> Click on <strong>Next: Configure Security Group</strong> <br />\n> Fill in:<br />"
echo -e "Security group name: <mark>$5</mark><br />\nDescription: <mark> this is my security group for my EC2 instance $4 </mark><br />\n> Click on the <strong>&#9747;</strong> on the right to remove first default rule of security group <br />\n> Click on <strong>Review and Launch</strong> <br />\n> Click on <strong>Launch</strong> <br />\n"
echo -e "Select: <strong>Create a new key pair</strong><br />\nFill in: <mark>$6</mark><br />\n> Click on <strong>Download Key Pair</strong> <br />\n> Click on <strong>Launch Instances</strong> <br /></p>\n"
let step_number++
}

create_a_NAT_instance ()
# write steps on how to create an internet gateway that connects a vpc to internet
# Entries:
#	$1 if "Auto-assign Public IP = yes" then enable Auto-assign Public IP
#	   if not then keep default Auto-assign Public IP option (disable)
#	$2 VPC tag name
#	$3 subnet tag name
#	$4 tag of nat instance
#	$5 tag of SG of instance
#	$6 tag of keypair of instance  
{
let n_nat_instance++
echo -e "\t\t <h1> Step $step_number: create a NAT instance $4 </h1>"
echo -e "\n<p>> Go to <em>Services/EC2/Instances</em><br />\n> Click on <strong>Launch Instance</strong><br />\n> Go to <em>Community AMIs</em><br />\n> In search bar, look for <mark>amzn-ami-vpc-nat</mark><br />\n> <strong>Select</strong> an AMI such as <strong> ami-00a9d4a05375b2763</strong><br />\n> Click on <strong>Next: Configure Instance Details</strong><br />\nRemark: here we could have chosen our instance type based on bandwidth<br />\n> Fill in:<br />"
if [ "$1" == "Auto-assign Public IP = yes" ]
then
	echo -e "Number of instances: <mark>1</mark><br />\nNetwork: <mark>$2</mark><br />\nSubnet: <mark>$3</mark><br />\nAuto-assign public IP: <mark>Enable</mark> <br />\n> Click on <strong>Next: Add Storage</strong> <br />\n> Click on <strong>Next: Add Tags</strong> <br /> \n>Fill in:<br />"
else
	echo -e "Number of instances: <mark>1</mark><br />\nNetwork: <mark>$2</mark><br />\nSubnet: <mark>$3</mark><br />\n> Click on <strong>Next: Add Storage</strong> <br />\n> Click on <strong>Next: Add Tags</strong> <br /> \n>Fill in:<br />"
fi
echo -e "Key: <mark>Name</mark><br />\nValue: <mark>$4</mark><br />\n> Click on <strong>Next: Configure Security Group</strong> <br />\n> Fill in:<br />"
echo -e "Security group name: <mark>$5</mark><br />\nDescription: <mark> this is my security group for my NAT instance $4 </mark><br />\n> Click on the <strong>&#9747;</strong> on the right to remove first default rule of security group <br />\n> Click on <strong>Review and Launch</strong> <br />\n> Click on <strong>Launch</strong> <br />\n"
echo -e "Select: <strong>Proceed without a key pair</strong><br />\nTick the box <mark> &#9745; </mark> to acknowledge the fact that you will not be able to access your instance<br />\n> Click on <strong>Launch Instances</strong> <br />\n"
echo -e "\n<p>> Finally in <em>Services/EC2/Instances</em><br />\n> Click on/select <strong>$4</strong><br />\n> Then click on <strong>Action</strong><br />\n> Click on <strong>Networking</strong><br />\n> Click on <strong>Change Source/Dest. Check</strong><br />\n> And click on <strong>Yes, Disable</strong><br /></p>\n"
let step_number++
}


create_a_route_table ()
# write steps on how to create an internet gateway that connects a vpc to internet
# Entries:
#	$1 VPC tag name
#	$2 route table tag name
{
let n_root_table++
echo -e "\t\t <h1> Step $step_number: create a route table $2</h1>"
echo -e "\n<p>> Go to <em>Services/VPC/Route Tables</em><br />\n> Click on <strong>Create a route table</strong><br />\n> Fill in:<br />"
echo -e "Name tag: <mark>$2</mark><br />\nVPC: <mark>$1</mark><br />\n> Click on <strong>Create</strong> <br /> </p> \n"
let step_number++
}

create_an_elastic_IP ()
# write steps on how to create an elastic IP address
#	$1 tag of elastic IP of instance 
{
echo -e "\t\t <h1> Step $step_number: create an elastic IP $1</h1>"
echo -e "\n<p>> Go to <em>Services/VPC/Elastic IPs</em><br />\n> Click on (select) <strong> Allocate new address </strong> <br />\n> Click on <strong> Allocate </strong> <br />\n> In <em>Services/VPC/Elastic IPs</em> click on <strong>Actions</strong><br />\n> Click on <strong>Add/Edit Tags</strong><br />\n> Click on <strong> Create Tag </strong> <br />\n> Fill in: <br />"
echo -e "Key <mark>Name</mark><br />\nValue: <mark>$main_tag-elastic-IP</mark> <br />\n> Click on <strong> Save </strong> <br /></p>\n"
let step_number++
}

attach_an_elastic_IP ()
# write steps on how to attach an elastic IP address to an instance
# Entries:
#	$1 Block #1 of VPC
#	$2 Block #2 of VPC
#	$3 tag of instance 
{
echo -e "\t\t <h1> Step $step_number: attach an elastic IP $to VPC </h1>"
echo -e "\n<p>> Go to <em>Services/VPC/Elastic IPs</em><br />\n> Click on <strong> Actions </strong> <br />\n> Click on <strong> Associate address </strong> <br />\n> Fill in:<br />"
echo -e "Instance: <mark>$3</mark><br />\nPrivate IP: <mark>$1.$2.$n_subnets.xxx</mark> (private IP of instance)<br />\n> Tick the box <mark> &#9745; </mark> to allow <strong> Reassociation </strong> <br />\n> Click on <strong> Associate </strong> <br /></p>\n"
let step_number++
}

ping_an_instance ()
# write steps on how to ping an instance
# Entries:
#	$1 tag name of instance 
#	$2 tag name of SG of instance 
{
echo -e "\t\t <h1> Step $step_number: ping an instance whose security group is $2 </h1>"
echo -e "\n<p>> Go to <em>Services/VPC/Instances</em><br />\n> Click on (select) <strong> $1 </strong> <br />\n> Below in <em>Description/Security groups</em> click on <strong> $2 </strong> with blue link <br />\n> Click on <strong> Inbounds </strong> <br />\n> Click on <strong> Edit </strong><br />\n> Click on <strong> Add Rule </strong><br />\n> Fill in:<br />"
echo -e "Type: <mark>All ICMP - IPv4</mark><br />\nSource: <mark>Anywhere</mark><br />\n> Click on <strong> Save </strong> <br />\n"
echo -e "Now using the <strong>public IP (or elastic IP)</strong> associated with our instance <strong>$1</strong> we can ping our instance.<br />\n> In a console (terminal or shell) of your computer just type: <span style=\"color: #ffffff; background-color: #000000\"> ping xxx.xxx.xxx.xxx </span> <br /></p>\n"
let step_number++
}

allow_SSH_from_instanceA_to_instanceB ()
# write steps on how to ping an instance
# Entries:
#	$1 tag name of instanceA
#	$2 tag name of instanceB
#	$3 tag name of SG of instanceA
#	$4 tag name of SG of instanceB 
{
echo -e "\t\t <h1> Step $step_number: allow SSH from $1 to $2</h1>"
echo -e "\n<p>> Go to <em>Services/VPC/Instances</em><br />\n> Click on (select) <strong> $2 </strong> <br />\n> Below in <em>Description/Security groups</em> click on <strong> $4 </strong> with blue link <br />\n> Click on <strong> Inbounds </strong> <br />\n> Click on <strong> Edit </strong><br />\n> Click on <strong> Add Rule </strong><br />\n> Fill in:<br />"
echo -e "Type: <mark> SSH </mark><br />\nSource: <mark>custom</mark><br /> then in empty box write/select <mark>$3</mark><br />\n> Click on <strong> Save </strong> <br />\n"
echo -e "Now by simply editing inbounds rules of $2 we allowed SSH exchange between $1 and $2 as:<br />\n- Outbound rules allow all traffic by default<br />\n- AWS is so called \"stateful\" hence new Inbound permissions imply by default symmetric permissions in Outbound rules<br /></p>\n"
let step_number++
}

allow_TCP_from_instanceA_to_instanceB ()
# write steps on how to ping an instance
# Entries:
#	$1 tag name of instanceA
#	$2 tag name of instanceB
#	$3 tag name of SG of instanceA
#	$4 tag name of SG of instanceB 
{
echo -e "\t\t <h1> Step $step_number: allow TCP from $1 to $2</h1>"
echo -e "\n<p>> Go to <em>Services/VPC/Instances</em><br />\n> Click on (select) <strong> $2 </strong> <br />\n> Below in <em>Description/Security groups</em> click on <strong> $4 </strong> with blue link <br />\n> Click on <strong> Inbounds </strong> <br />\n> Click on <strong> Edit </strong><br />\n> Click on <strong> Add Rule </strong><br />\n> Fill in:<br />"
echo -e "Type: <mark> All TCP </mark><br />\nSource: <mark>custom</mark><br /> then in empty box write/select <mark>$3</mark><br />\n> Click on <strong> Save </strong> <br />\n"
echo -e "Now by simply editing inbounds rules of $2 we allowed all TCP exchange between $1 and $2 as:<br />\n- Outbound rules allow all traffic by default<br />\n- AWS is so called \"stateful\" hence new Inbound permissions imply by default symmetric permissions in Outbound rules<br /></p>\n"
let step_number++
}

allow_ICMP_from_instanceA_to_instanceB ()
# write steps on how to ping an instance
# Entries:
#	$1 tag name of instanceA
#	$2 tag name of instanceB
#	$3 tag name of SG of instanceA
#	$4 tag name of SG of instanceB 
{
echo -e "\t\t <h1> Step $step_number: allow ICMP from $1 to $2</h1>"
echo -e "\n<p>> Go to <em>Services/VPC/Instances</em><br />\n> Click on (select) <strong> $2 </strong> <br />\n> Below in <em>Description/Security groups</em> click on <strong> $4 </strong> with blue link <br />\n> Click on <strong> Inbounds </strong> <br />\n> Click on <strong> Edit </strong><br />\n> Click on <strong> Add Rule </strong><br />\n> Fill in:<br />"
echo -e "Type: <mark> All ICMP IPv4 </mark><br />\nSource: <mark>custom</mark><br /> then in empty box write/select <mark>$3</mark><br />\n> Click on <strong> Save </strong> <br />\n"
echo -e "Now by simply editing inbounds rules of $2 we allowed ICMP exchange between $1 and $2 as:<br />\n- By default $2 could send ICMP message to $1 but not receive respond<br />\n- We allowed $2 to receive ICMP message coming from $1<br /></p>\n"
let step_number++
}

connect_to_an_instance ()
# write steps on how to ping an instance
# Entries:
#	$1 tag name of instance 
#	$2 tag name of keypair of instance
{
echo -e "\t\t <h1> Step $step_number: connect to an instance $1</h1>"
echo -e "\n<p>> Go to <em>Services/VPC/Instances</em><br />\nMake sure your instance $1 is <span style="color:MediumSeaGreen">running</span>, if not then:<br />\n> Click on (select) <strong> $1 </strong> <br />\n> Click on <strong>Actions</strong> <br />\n> Click on <strong> Instance State </strong> <br />\n> Click on <strong> Start </Strong><br />"
echo -e "Then <strong>on your computer</strong> do the following steps: <br />\n"
echo -e "> Go to the <strong>directory</strong> which contains the private key of your instance <strong>$2.pem</strong><br />\n> In a console (terminal or shell) type the following: <span style=\"color: #ffffff; background-color: #000000\">chmod 400 $2.pem</span><br />\nIt makes sure your key file is not publicly visible<br />\n> In your console (terminal) type the following: <span style=\"color: #ffffff; background-color: #000000\">ssh -i \"$2.pem\" ec2-user@xxx.xxx.xxx.xxx</span><br />\nWhere xxx.xxx.xxx.xxx is the public IP (or elastic IP) of our instance<br />\n> If it askes <strong>Are you sure you want to continue connecting (yes/no)?</strong> then type <span style=\"color: #ffffff; background-color: #000000\">yes</span><br /></p>\n"
let step_number++
}

###################
# Build tutorials #
###################

choice_of_tutorial()
# return steps corresponding to a chosen tutorial
# Entries:
# $1 n* corresponding to the chosen tutorial 
{
if [ $1 -eq 1 ]
then
	echo -e "\t\t <h1> Tutorial: create a public EC2 instance + connect to instance </h1>"
	STEP0='get to AWS'
	STEP1='create a VPC'
	STEP2='create a (private) subnet'
	STEP3='create an internet gateway'
	STEP4='attach an internet gateway to VPC'
	STEP5='make a subnet public: connect a subnet to internet'
	STEP6='create an EC2 instance'
	STEP7='connect to an EC2 instance'
	menu "$STEP0" "$STEP1" "$STEP2" "$STEP3" "$STEP4" "$STEP5" "$STEP6" "$STEP7"

	step_number=0
	n_VPC=0
	n_subnets=0
	n_private_subnets=0
	n_public_subnets=0
	n_IGW=0
	n_ec2_instance=0

	tag_vpc="$main_tag-vpc" 
	tag_private_subnet="$main_tag-private-subnet"
	tag_public_subnet="$main_tag-public-subnet"
	tag_igw="$main_tag-igw"
	tag_ec2="$main_tag-public-ec2"
	tag_sg="$main_tag-sg"
	tag_keypair="$main_tag-keypair"

	be_ready 
	create_a_vpc $tag_vpc
	create_a_subnet $RN1 $RN2 us-east-1a $tag_vpc $tag_private_subnet
	create_an_IG $tag_igw
	attach_an_IG $tag_vpc $tag_igw
	make_a_subnet_public $tag_igw $tag_private_subnet $tag_public_subnet
	create_an_EC2_instance "Auto-assign Public IP = yes" $tag_vpc $tag_public_subnet $tag_ec2 $tag_sg $tag_keypair 
	connect_to_an_instance $tag_ec2 $tag_keypair
	ending	

elif [ $1 -eq 2 ]
then
	echo -e "\t\t <h1> Tutorial: create a public EC2 instance + elastic IP + ping instance + connect to instance </h1>"
	STEP0='get to AWS'
	STEP1='create a VPC'
	STEP2='create a (private) subnet'
	STEP3='create an internet gateway'
	STEP4='attach an internet gateway to VPC'
	STEP5='make a subnet public: connect a subnet to internet'
	STEP6='create an EC2 instance'
	STEP7='create an elastic IP'
	STEP8='attach an elastic IP to an instance'
	STEP9='ping an instance'
	STEP10='connect to an instance'
	menu "$STEP0" "$STEP1" "$STEP2" "$STEP3" "$STEP4" "$STEP5" "$STEP6" "$STEP7" "$STEP8" "$STEP9" "$STEP10"

	step_number=0
	n_VPC=0
	n_subnets=0
	n_private_subnets=0
	n_public_subnets=0
	n_IGW=0
	n_ec2_instance=0

	tag_vpc="$main_tag-vpc" 
	tag_private_subnet="$main_tag-private-subnet"
	tag_public_subnet="$main_tag-public-subnet"
	tag_igw="$main_tag-igw"
	tag_ec2="$main_tag-public-ec2"
	tag_sg="$main_tag-sg"
	tag_keypair="$main_tag-keypair"
	tag_eip="$baseline-elastic-ip"

	be_ready 
	create_a_vpc $tag_vpc
	create_a_subnet $RN1 $RN2 us-east-1a $tag_vpc $tag_private_subnet
	create_an_IG $tag_igw
	attach_an_IG $tag_vpc $tag_igw
	make_a_subnet_public $tag_igw $tag_private_subnet $tag_public_subnet
	create_an_EC2_instance "Auto-assign Public IP = no" $tag_vpc $tag_public_subnet $tag_ec2 $tag_sg $tag_keypair
	create_an_elastic_IP $tag_eip
	attach_an_elastic_IP $RN1 $RN2 $tag_ec2
	ping_an_instance $tag_ec2 $tag_sg
	connect_to_an_instance $tag_ec2 $tag_keypair
	ending

elif [ $1 -eq 3 ]
then

	step_number=0
	n_VPC=0
	n_subnets=0
	n_private_subnets=0
	n_public_subnets=0
	n_route_table=0
	n_IGW=0
	n_ec2_instance=0
	n_nat_instance=0

	tag_vpc="$main_tag-vpc"
	tag_igw="$main_tag-igw"

	tag_public_subnet="$main_tag-public-subnet"
	tag_private_subnet="$main_tag-private-subnet"
	tag_rt_private_subnet="$main_tag-rt-private-subnet"

	tag_jb="$main_tag-jumpbox"
	tag_sg_jb="$main_tag-sg-jumpbox"
	tag_keypair_jb="$main_tag-keypair-jumpbox"

	tag_nat="$main_tag-nat"
	tag_sg_nat="$main_tag-sg-nat"

	tag_private_ec2="$main_tag-private-ec2"
	tag_sg_private_ec2="$main_tag-sg-private-ec2"
	tag_keypair_private_ec2="$main_tag-keypair-private-ec2"

	echo -e "\t\t <h1> Tutorial: create a public subnet with jumpbox and NAT instances + private subnet with EC2 instance + ping from private instance </h1>"
	STEP0="get to AWS"
	STEP1="create a VPC $tag_vpc"
	STEP2="create a (private) subnet $tag_public_subnet"
	STEP3="create an internet gateway $tag_igw"
	STEP4="attach an internet gateway $tag_igw to VPC $tag_vpc"
	STEP5="connect a subnet $tag_public_subnet to internet gateway $tag_igw"
	STEP6="create an EC2 instance $tag_jb with public IP"
	STEP7="allow any IP to connect to $tag_jb through SSH"
	STEP8="create a NAT instance $tag_nat"
	STEP9="create a (private) subnet $tag_private_subnet"
	STEP10="create a route table $tag_rt_private_subnet"
	STEP11="connect subnet $tag_private_subnet to NAT instance $tag_nat"
	STEP12="create an EC2 instance $tag_private_ec2"
	STEP13="connect $tag_private_ec2"
	STEP13="create an EC2 instance $tag_private_ec2"
	STEP13="create an EC2 instance $tag_private_ec2"
	menu "$STEP0" "$STEP1" "$STEP2" "$STEP3" "$STEP4" "$STEP5" "$STEP6"

	be_ready 
	echo -e "\t\t <img src=\"aws.png\" alt=\"aws\" title=\"aws\" width="500" height="300" /> \n"
	create_a_vpc $tag_vpc
	echo -e "\t\t <img src=\"vpc.png\" alt=\"vpc\" title=\"vpc\" width="500" height="300" /> \n"
	create_a_subnet $RN1 $RN2 us-east-1a $tag_vpc $tag_public_subnet
	echo -e "\t\t <img src=\"private_subnet.png\" alt=\"private_subnet\" title=\"private_subnet\" width="500" height="300" /> \n"
	create_an_IG $tag_igw
	attach_an_IG $tag_vpc $tag_igw
	echo -e "\t\t <img src=\"private_subnet_IGW.png\" alt=\"private_subnet_IGW\" title=\"private_subnet_IGW\" width="500" height="300" /> \n"
	connect_subnet_to_igw $tag_igw $tag_public_subnet
	echo -e "\t\t <img src=\"public_subnet_IGW.png\" alt=\"public_subnet_IGW\" title=\"public_subnet_IGW\" width="500" height="300" /> \n"
	create_an_EC2_instance "Auto-assign Public IP = yes" $tag_vpc $tag_public_subnet $tag_jb $tag_sg_jb $tag_keypair_jb 
	echo -e "\t\t <img src=\"public_ec2.png\" alt=\"public_ec2\" title=\"public_ec2\" width="500" height="300" /> \n"
	allow_SSH_from_instanceA_to_instanceB world $tag_jb 0.0.0.0/0 $tag_sg_jb
	create_a_NAT_instance "Auto-assign Public IP = no" $tag_vpc $tag_public_subnet $tag_nat $tag_sg_nat
	create_a_subnet $RN1 $RN2 us-east-1a $tag_vpc $tag_private_subnet
	create_a_route_table $tag_vpc $tag_rt_private_subnet
	connect_subnet_to_nat_instance $tag_nat $tag_private_subnet
	create_an_EC2_instance "Auto-assign Public IP = no" $tag_vpc $tag_private_subnet $tag_private_ec2 $tag_sg_private_ec2 $tag_keypair_private_ec2
	allow_SSH_from_instanceA_to_instanceB $tag_jb $tag_private_ec2 $tag_sg_jb $tag_sg_private_ec2
	allow_TCP_from_instanceA_to_instanceB $tag_nat $tag_private_ec2 $tag_sg_nat $tag_sg_private_ec2
	allow_ICMP_from_instanceA_to_instanceB $tag_nat $tag_private_ec2 $tag_sg_nat $tag_sg_private_ec2
	allow_ICMP_from_instanceA_to_instanceB world $tag_nat 0.0.0.0/0 $tag_sg_nat
	ending
fi
}

##############
# User query #
##############

echo -e "\n\n********************* WELCOME TO AWS HELPER *********************\n"

tutorial1="create a public EC2 instance + connect to instance"
tutorial2="create a public EC2 instance + elastic IP + ping instance + connect to instance"
tutorial3="create a public subnet with jumpbox and NAT instances + private subnet with EC2 instance + ping from private instance"

echo -e "Available tutorials:\n"
echo -e "\tID\t->\t\t\t\tTutorial Content"
echo -e "\t1\t->\t$tutorial1"
echo -e "\t2\t->\t$tutorial2"
echo -e "\t3\t->\t$tutorial3\n"

read -p "Choose a tutorial (ID): " tutorial_id

if [ $tutorial_id -eq 1 ]
then
	echo -e "chosen tutorial: $tutorial1\n"
elif [ $tutorial_id -eq 2 ]
then
	echo -e "chosen tutorial: $tutorial2\n"
elif [ $tutorial_id -eq 3 ]
then
	echo -e "chosen tutorial: $tutorial3\n"
else
	echo -e "!!!!Tutorial ID unknown!!!!!\nYou should enter 1 or 2\n"
	exit
fi
read -p "Enter a name for your setup which will be used to generate tag names: " main_tag
echo "chosen main tag name: $main_tag"

######################
# Write an HTML page #
######################

head "$title" > $html_file

welcome "$title" "$author" >> $html_file

choice_of_tutorial $tutorial_id >> $html_file

#######
# End #
#######

echo -e "\n>>>>> tutorial has been generated \nplease open *helper.html* in current directory"

open ./aws_helper.html

#rm aws_helper.html

