<?
function get_client_ip()
{
        $s_client_ip;
        if ($_SERVER['REMOTE_ADDR'])
        {
                $s_client_ip = $_SERVER['REMOTE_ADDR'];
        }
        elseif (getenv('REMOTE_ADDR'))
        {
                $s_client_ip = getenv('REMOTE_ADDR');
        }
        elseif (getenv('HTTP_CLIENT_IP'))
        {
                $s_client_ip = getenv('HTTP_CLIENT_IP');
        }
        else
        {
                $s_client_ip = 'unknown';
        }
        return $s_client_ip;
}

//��̬�ֲ����������������̬�ֲ�
function gauss() {
        $randmax = getrandmax();

        $v = 2;
        while ($v > 1) {
                $u1 = rand(0, $randmax) / $randmax;
                $u2 = rand(0, $randmax) / $randmax;

                $v = (2 * $u1 - 1) * (2 * $u1 - 1) + (2 * $u2 - 1) * (2 * $u2 - 1);
        }

        return (2* $u1 - 1) * sqrt( -2 * log($v) / $v);
}


//��ý��
function getAward()
{
        //�����̬�ֲ�ֵ
        $gauss = gauss();

        //�淶����
        if ($gauss < -1) $gauss = -1;
        if ($gauss > 1)  $gauss = 1;

        $award = floor(($gauss + 1)*1000);

        return ($award > 50)?$award:50;
}

    
