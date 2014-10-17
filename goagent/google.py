#!coding:utf-8

import urllib2
import socket
import time
import re
import sys
import os

def get_connect_time(ipaddress, port):
    try:
        socket.setdefaulttimeout(1)
        s=socket.socket()
        start=time.time()
        s.connect((ipaddress, port))
        end=time.time()
        s.close()
    except:
        print 'Connect %s timeout' %(ipaddress)
        end='error'
        s.close()
        return '3000'

    try:
        socket.setdefaulttimeout(1)
        s=socket.socket()
        start=time.time()
        s.connect((ipaddress, port))
        end=time.time()
        s.close()
    except:
        print 'Connect %s timeout' %(ipaddress)
        end='error'
        s.close()
        return '3000'

    if end!='error':
        connect_time=end-start
	print 'found ip %s 连接时间:%s ms' %(ipaddress,str(int(connect_time*1000)))
       # print connect_time
        connect_time=int(connect_time*1000)
        return connect_time
    else:
        return '3000'


def get_host_file(html):

    #print html
    text=r'\d+\.\d+\.\d+\.\d+'
    ip=re.findall(text, html)
    #print ip
    iplist=[]
    for a in ip:
        if a in iplist:
            pass
        else:
            iplist.append(a)

    if '127.0.0.1' in iplist:
        iplist.remove('127.0.0.1')
        return iplist

    return iplist

def banner():
    print '参数错误'
    print '---------------------------------------------------------------------------------'
    print '---  本程序支持从文件导入ip，也支持从网页正则提取ip                           ---'
    print '---  用法：                                                                   ---'
    print '---  python google.py http://www.freebuf.com/articles/others-articles/36452.html-'
    print '---  python google.py ip.txt                                                  ---'
    print '---                                                  by 羽音                  ---'
    print '---------------------------------------------------------------------------------'

def main():
    argv=sys.argv
    #print len(argv)
    if len(argv)<3:
        banner()
        sys.exit(0)
    if '-f' not in argv and '-u' not in argv:
        banner()
    else:
        urladdress=''
        filename=''
        if '-u' in argv:
            urladdress=argv[argv.index('-u')+1]
        if '-f' in argv:
            filename=argv[argv.index('-f')+1]

        if urladdress=='':
            handle=open(filename)
            html=handle.read()

        else:
            html=urllib2.urlopen(urladdress)
            html=html.read()

        ip=get_host_file(html)
        print 'found %s ip' %(str(len(ip)))
        print 'starting connect...'
        print '------------------------------'
        usefulip=[]
        for a in ip:
            connect_time=get_connect_time(a, 443)
            #print connect_time
            if connect_time<=2000:
                usefulip.append([connect_time, a])
        ip=[]
        for a in range(0, len(usefulip)):
            min_time_ip=min(usefulip)
            ip.append(min_time_ip)
            usefulip.remove(min_time_ip)
        print ip
        #handle=open('output.txt', 'w')
        text=''
        for a in ip:
            text=text+'|'+a[1]
        print '\n结果:%s' % text[1:]
        #handle.close()


if __name__ == '__main__':
    main()
