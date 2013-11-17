//监控5分钟: node watch.js 5 

var os  = require('os');
var fs  = require('fs');
var exec = require('child_process').exec;
var mongodb  = require('./mongodb');
    mongodb.connect('mongodb://192.168.0.8/serverStatus');

var period = 5*60;                       //数据采集总时长(s)；请以分钟为最小采集单位

if('undefined' != typeof(process.argv[2]) && parseInt(process.argv[2]) > 1){
    period = parseInt(process.argv[2])*60;
}
console.log('period : '+period);

var internal = 2;                        //数据采集时间间隔(s)；
var count = parseInt(60/internal);       //计算1分钟内需要数据采集的次数；
var storeType = 'mongodb';               //存储类型：mongodb/file

var myTime = function(){    
    var now = new Date();
    return now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate()+' '+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds(); 
};

var trim = function(s){
    return s.replace(/\s+/g,' ');
};

var status_info = {
        'ip'         : 'localhost',
        'systemtype' : os.type(),
        'release'    : os.release(),
        'totalmem'   : parseInt(os.totalmem()/1024),
        'cpus'       : os.cpus().length,
        'status'     : {
            'period'     : period,
            'internal'   : internal,
            'start_time' : '',
            'end_time'   : '',
            'cpu'        : '',
            'mem'        : '',
            'io'         : '',
            'net'        : '',
            'load'       : '',
        }
    };

//IP: /sbin/ifconfig | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d : -f2 | awk '{print $1}'
exec("/sbin/ifconfig | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d : -f2 | awk '{print $1}'",
  function (error, stdout, stderr) {
    if (error !== null) {
        console.log('exec error: ' + error);
    }else{
        status_info.ip = stdout.replace('\n','');
        if('mongodb' == storeType){
            var serverData = {
                ip: status_info.ip, 
                systemtype: status_info.systemtype, 
                release: status_info.release,
                totalmem: status_info.totalmem,
                cpus: status_info.cpus,
            }
            mongodb.save('Server',serverData);
            console.log('Server info has saved !');
        }
    }
});

var store = function(type,data,startTime){
    if('mongodb' == storeType){
        var statusData = {}
            statusData.ip = data.ip;
            statusData.start_time = startTime;
            statusData.end_time = myTime('datetime');
        if('cpu' == type){
            for(var k in data){
                statusData.time = data[k][0]+' '+data[k][1];
                statusData.cpu = data[k][2];
                statusData.user = data[k][3];
                statusData.nice = data[k][4];
                statusData.system = data[k][5];
                statusData.iowait = data[k][6];
                statusData.steal = data[k][7];
                statusData.idle = data[k][8];
                mongodb.save('CpuStatus',statusData);
            }
            console.log('start time : '+startTime+'; CpuStatus has saved !');
        }else if('mem' == type){
            for(var k in data){
                statusData.time = data[k][0]+' '+data[k][1];
                statusData.kbmemfree = data[k][2];
                statusData.kbmemused = data[k][3];
                statusData.memused = data[k][4];
                statusData.kbbuffers = data[k][5];
                statusData.kbcached = data[k][6];
                statusData.kbcommit = data[k][7];
                statusData.commit = data[k][8];
                mongodb.save('MemStatus',statusData);
            }
            console.log('start time : '+startTime+'; MemStatus has saved !');
        }else if('io' == type){
            for(var k in data){
                statusData.time = data[k][0]+' '+data[k][1];
                statusData.tps = data[k][2];
                statusData.rtps = data[k][3];
                statusData.wtps = data[k][4];
                statusData.bread = data[k][5];
                statusData.bwrtn = data[k][6];
                mongodb.save('IoStatus',statusData);
            }
            console.log('start time : '+startTime+'; IoStatus has saved !');
        }else if('net' == type){
            for(var k in data){
                statusData.time = data[k][0]+' '+data[k][1];
                statusData.IFACE = data[k][2];
                statusData.rxpck = data[k][3];
                statusData.txpck = data[k][4];
                statusData.rxkB = data[k][5];
                statusData.txkB = data[k][6];
                statusData.rxcmp = data[k][7];
                statusData.txcmp = data[k][8];
                statusData.rxmcst = data[k][9];
                mongodb.save('NetStatus',statusData);
            }
            console.log('start time : '+startTime+'; NetStatus has saved !');
        }else if('loadavg' == type){
            for(var k in data){
                statusData.time = data[k][0]+' '+data[k][1];
                statusData.runqSz = data[k][2];
                statusData.plistSz = data[k][3];
                statusData.ldavg1 = data[k][4];
                statusData.ldavg5 = data[k][5];
                statusData.ldavg15 = data[k][6];
                mongodb.save('LoadavgStatus',statusData);
            }
            console.log('start time : '+startTime+'; LoadavgStatus has saved !');
        }
        return;
    }
    status_info.status[type] = data;
    if(status_info.status.cpu && status_info.status.mem && status_info.status.io && status_info.status.net && status_info.status.loadavg){
        status_info.status.start_time = startTime;
        status_info.status.end_time = myTime('datetime');
        var status_file = "/home/node/status_info_"+startTime.replace(/\:/g,'_')+".txt"; 
        var status_data = JSON.stringify(status_info);
        status_info.status.start_time = '';
        status_info.status.end_time = '';
        status_info.status.cpu = '';
        status_info.status.mem = '';
        status_info.status.io = '';
        status_info.status.net = '';
        status_info.status.loadavg = '';
        fs.writeFile(status_file,status_data,function(){ 
            console.log('start time : '+startTime+'; file : '+status_file);
        });
    }
};

var watchNow = function(){
    var startTime = myTime('datetime');
    
    //CPU: TIME     CPU     %user     %nice   %system   %iowait    %steal     %idle
    exec('sar -u '+internal+' '+count,
      function (error, stdout, stderr) {
        if (error !== null) {
           console.log('exec error: ' + error);
        }else{
           var data = new Array;
           var stdout = stdout.split('\n');
           var k=0;
           for(var i in stdout){
              if(stdout[i].length && stdout[i].indexOf('Linux') == -1 && stdout[i].indexOf('Average') == -1 && stdout[i].indexOf('idle') == -1){
                  data[k] = trim(stdout[i]).split(' ');
                  k++;
              }
           }
           store('cpu',data,startTime);
        }
    });

    //内存: TIME      kbmemfree kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit
    exec('sar -r '+internal+' '+count,
      function (error, stdout, stderr) {
        if (error !== null) {
           console.log('exec error: ' + error);
        }else{
           var data = new Array;
           var stdout = stdout.split('\n');
           var k=0;
           for(var i in stdout){
              if(stdout[i].length && stdout[i].indexOf('Linux') == -1 && stdout[i].indexOf('Average') == -1 && stdout[i].indexOf('commit') == -1){
                  data[k] = trim(stdout[i]).split(' ');
                  k++;
              }
           }
           store('mem',data,startTime);
        }
    });
    
    //IO: TIME      tps      rtps      wtps   bread/s   bwrtn/s
    exec('sar -b '+internal+' '+count,
      function (error, stdout, stderr) {
        if (error !== null) {
           console.log('exec error: ' + error);
        }else{
           var data = new Array;
           var stdout = stdout.split('\n');
           var k=0;
           for(var i in stdout){
              if(stdout[i].length && stdout[i].indexOf('Linux') == -1 && stdout[i].indexOf('Average') == -1 && stdout[i].indexOf('bwrtn') == -1){
                  data[k] = trim(stdout[i]).split(' ');
                  k++;
              }
           }
           store('io',data,startTime);
        }
    });
    
    
    //网络状态: TIME      IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
    exec('sar -n DEV '+internal+' '+count,
      function (error, stdout, stderr) {
        if (error !== null) {
           console.log('exec error: ' + error);
        }else{
           var data = new Array;
           var stdout = stdout.split('\n');
           var k=0;
           for(var i in stdout){
              if(stdout[i].length && stdout[i].indexOf('Linux') == -1 && stdout[i].indexOf('Average') == -1 && stdout[i].indexOf('rxmcst') == -1){
                  data[k] = trim(stdout[i]).split(' ');
                  k++;
              }
           }
           store('net',data,startTime);
        }
    });
    
    //进程队列长度和平均负载: TIME      runq-sz  plist-sz   ldavg-1   ldavg-5  ldavg-15
    exec('sar -q '+internal+' '+count,
      function (error, stdout, stderr) {
        if (error !== null) {
           console.log('exec error: ' + error);
        }else{
           var data = new Array;
           var stdout = stdout.split('\n');
           var k=0;
           for(var i in stdout){
              if(stdout[i].length && stdout[i].indexOf('Linux') == -1 && stdout[i].indexOf('Average') == -1 && stdout[i].indexOf('ldavg') == -1){
                  data[k] = trim(stdout[i]).split(' ');
                  k++;
              }
           }
           store('loadavg',data,startTime);
        }
    });

};

period-=60;
watchNow();

var watchInterval = setInterval(function(){
    if( period ){
        period-=60;
        watchNow();
    }else {
        clearInterval(watchInterval);
        setTimeout(function(){
            console.log('All done !');
            process.exit();    
        },1000*internal);
    }
},1000*60);
